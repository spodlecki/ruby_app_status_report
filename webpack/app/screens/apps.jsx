import React, {Component} from 'react';
import PropTypes from 'prop-types'
import {
  HashRouter as Router,
  Route
} from 'react-router-dom'

import { AppDisplay } from 'app/screens/apps/display'
import { AppIndex } from 'app/screens/apps/index'
import { AppNew } from 'app/screens/apps/new'

const AppsScreen = ({ match }) => (
  <Router>
    <div>
      <Route path={match.url} exact component={AppIndex} />
      <Route exact path={`${match.url}/new`} component={AppNew} />
      <Route path={`${match.url}/:id(\\d+)`} component={AppDisplay} />
    </div>
  </Router>
)

export { AppsScreen }
