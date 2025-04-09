// For Finicky.app per https://github.com/johnste/finicky

module.exports = {
    defaultBrowser: "Safari",
    options: {
        hideIcon: false
    },

    handlers: [
        {
            match: [
                /http(s)?:\/\/[^/]*(jamboard|analytics|meet|chrome|calendar|mail|docs|cloud|console.cloud|drive|groups|sites)\.google\.com(\/.*)?/,
                /http(s)?:\/\/[^/]*gmail\.com(\/.*)?/,
                /http(s)?:\/\/[^/]*forms\.gle(\/.*)?/,
                /http(s)?:\/\/[^/]*ceph.odell.sh(\/.*)?/,
            ],
            // I always see this and want to use it, but it seems to just
            // match the raw domain, not the domain followed by any
            // path, and it doesn't seem to match subdomains (e.g.
            // portal.insperity.com as opposed to just insperity.com)
            // finicky.matchDomains([
            //      "ceph.odell.sh",
            //      "insperity.com"
            //])
            browser: "Google Chrome"
        },

        // Workday stuff in Chrome, too
        {
            match: [
                /http(s)?:\/\/[^/]*lucid.app(\/.*)?/,
                /http(s)?:\/\/[^/]*miro.com(\/.*)?/,
                /http(s)?:\/\/[^/]*megaleo.com/,
                /http(s)?:\/\/[^/]*(my)?workday.com(\/.*)?/,
                /http(s)?:\/\/[^/]*workdayinternal.com(\/.*)?/,
                /http(s)?:\/\/[^/]*workday.okta.com(\/.*)?/,
                /http(s)?:\/\/[^/]*wolinks.com(\/.*)?/,
                /http(s)?:\/\/[^/]*urldefense.com(\/.*)?/,
                /http(s)?:\/\/[^/]*achievers.com/,
                /http(s)?:\/\/[^/]*(inday|wdpharos).io/,
                /http(s)?:\/\/[^/]*wdscylla.de/,
                /http(s)?:\/\/[^/]*workday[^/]*/,
                /http(s)?:\/\/[^/]*getcortexapp.com[^/]*/,
                /http(s)?:\/\/s2.bl-1.com\//,
            ],
            browser: "Google Chrome"
        },

        // Zoom join links open zoom directly, rather than first opening
        // a safari tab
        {
            match: /zoom\.us\/j\//,
            browser: "us.zoom.xos"
        },

        // Slack links open slack directly
        //{
        //    match: [
        //        /https:\/\/workday.enterprise.slack.com\/archives\/.*/,
        //        /https:\/\/workday-dev.slack.com\/archives\/.*/,
        //    ],
        //    browser: "/Applications/Slack.app"
        //},

        {
            match: ({ url }) => url.protocol === "slack",
            browser: "/Applications/Slack.app"
        },

        // NOTE: Thanks to folks on this thread, although this is my own, simpler solution.
        // See https://github.com/johnste/finicky/discussions/227
        {
            match: ({ url }) => url.host === "teams.microsoft.com",
            browser: "Microsoft Teams"
        }
    ],

    rewrite: [
        {
            match: [
                '*.slack.com/*',
            ],
            url: function({ url, urlString }) {
                const subdomain = url.host.slice(0, -10)
                const pathParts = url.pathname.split("/")

                let team, patterns = {}
                if (subdomain != 'app') {
                    switch (subdomain) {
                        case '<teamname>':
                        case '<corpname>.enterprise':
                            team = 'T00000000'
                            break
                        default:
                            finicky.notify(
                                `No Slack team ID found for ${url.host}`,
                                `Add the team ID to ~/.finicky.js to allow direct linking to Slack.`
                            )
                            return url
                    }

                    if (subdomain.slice(-11) == '.enterprise') {
                        patterns = {
                            'file': [/\/files\/\w+\/(?<id>\w+)/]
                        }
                    } else {
                        patterns = {
                            'file': [/\/messages\/\w+\/files\/(?<id>\w+)/],
                            'team': [/(?:\/messages\/\w+)?\/team\/(?<id>\w+)/],
                            'channel': [/\/(?:messages|archives)\/(?<id>\w+)(?:\/(?<message>p\d+))?/]
                        }
                    }
                } else {
                    patterns = {
                        'file': [
                            /\/client\/(?<team>\w+)\/\w+\/files\/(?<id>\w+)/,
                            /\/docs\/(?<team>\w+)\/(?<id>\w+)/
                        ],
                        'team': [/\/client\/(?<team>\w+)\/\w+\/user_profile\/(?<id>\w+)/],
                        'channel': [/\/client\/(?<team>\w+)\/(?<id>\w+)(?:\/(?<message>[\d.]+))?/]
                    }
                }

                for (let [host, host_patterns] of Object.entries(patterns)) {
                    for (let pattern of host_patterns) {
                        let match = pattern.exec(url.pathname)
                        if (match) {
                            let search = `team=${team || match.groups.team}`

                            if (match.groups.id) {
                                search += `&id=${match.groups.id}`
                            }

                            if (match.groups.message) {
                                let message = match.groups.message
                                if (message.charAt(0) == 'p') {
                                    message = message.slice(1, 11) + '.' + message.slice(11)
                                }
                                search += `&message=${message}`
                            }

                            let output = {
                                protocol: "slack",
                                username: "",
                                password: "",
                                host: host,
                                port: null,
                                pathname: "",
                                search: search,
                                hash: ""
                            }
                            let outputStr = `${output.protocol}://${output.host}?${output.search}`
                            finicky.log(`Rewrote Slack URL ${urlString} to deep link ${outputStr}`)
                            return output
                        }
                    }
                }

                return url
            }
        }
    ]
};
