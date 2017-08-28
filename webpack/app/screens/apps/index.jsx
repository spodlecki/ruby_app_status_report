import React, {Component} from 'react';
import PropTypes from 'prop-types';
import { AppRow } from './index/row'
import { Link } from 'react-router-dom'

class AppIndex extends Component {
  static propTypes = { }
  static defaultProps = { }

  constructor(props) {
    super(props);
    this.state = { applications: [] };
  }

  componentDidMount() {
    let options = { credentials: 'include' };
    fetch('/ruby_apps', options)
      .then(function(response) {
        let contentType = response.headers.get('content-type');
        if(contentType && contentType.includes('application/json')) {
          return response.json();
        }
        throw new TypeError('Response was not JSON.');
      })
      .then(json => {
        this.setState({applications: json});
      })
      .catch(function(error) { console.log(error); });
  }

  componentWillUnmount() {
    // any teardown
  }

  renderAppRow(item, key) {
    return (
      <AppRow key={key} {...item} />
    );
  }

  render() {
    return (
      <div className="app-list">
        <h1>
          Applications
        </h1>
        {this.state.applications.map(this.renderAppRow)}
        <Link to="/apps/new">need to add another app?</Link>
      </div>
    );
  }
}

export { AppIndex }
