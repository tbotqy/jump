new TWTR.Widget({
  version: 2,
  type: 'profile',
  rpp: 5,
  interval: 30000,
  width: 440,
  height: 250,
  theme: {
    shell: {
      background: '#f2eee6',
      //background: '#e8e0cf',
      color: '#8a631e'
    },
    tweets: {
      background: '#f2eee6',
      color: '#423b42',
      links: '#cd8500'
    }
  },
  features: {
    scrollbar: false,
    loop: false,
    live: true,
    behavior: 'all'
  }
}).render().setUser('timedline_tw').start();