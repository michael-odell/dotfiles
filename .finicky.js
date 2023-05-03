// For Finicky.app per https://github.com/johnste/finicky

module.exports = {
    defaultBrowser: "Safari",
    options: {
        hideIcon: false,

        // Change to true to see what URLs are flowing through finicky
        logRequests: false
    },
    handlers: [
        {
            match: [
                /(jamboard|analytics|meet|chrome|calendar|mail|docs|cloud|console.cloud|drive|groups|sites)\.google\.com(\/.*)?/,
                /gmail\.com(\/.*)?/,
                /insperity.com(\/.*)?/,
                /ceph.odell.sh(\/.*)?/,
                /lucid.app(\/.*)?/,
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
        }
    ]
};
