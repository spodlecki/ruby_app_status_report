import React, {Component} from 'react';
import PropTypes from 'prop-types'
import {
  HashRouter as Router,
  Route,
  Link,
  Redirect,
  withRouter
} from 'react-router-dom'

import { Navigation, navItem } from 'app/layout/navigation'
import { AppsScreen } from 'app/screens/apps'
import { Setup } from 'app/screens/setup'
import { Notifications } from 'app/screens/notifications'
import { Gems } from 'app/screens/gems'

const ROUTES = [
  navItem('Applications', '/apps', 'info'),
  // navItem('Alerts', '/alerts', 'bell-o'),
  // navItem('Setup', '/setup', 'cog'),
  navItem('Ruby Gems', '/gems', 'diamond')
]

/*
  This can eventually be controlled in a Router style
*/
const AppLayout = () => (
  <Router>
    <div>
      <Navigation navItems={ROUTES} />
      <div id="content">
        <Route exact path="/" render={()=> <Redirect to="/apps"/>} />
        <Route path="/apps" component={AppsScreen} />
        <Route path="/gems" component={Gems} />
        <Route path="/setup" component={Setup} />
        <Route path="/alerts" component={Notifications} />
      </div>
    </div>
  </Router>
)

export { AppLayout }
