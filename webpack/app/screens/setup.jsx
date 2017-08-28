import React, {Component} from 'react';
import PropTypes from 'prop-types';

class Setup extends Component {
  static propTypes = { }
  static defaultProps = { }

  constructor(props) {
    super(props);
  }

  componentDidMount() {
    // setup
  }

  componentWillUnmount() {
    // any teardown
  }

  render() {
    return (
      <div>
        <h1>Configuration</h1>
        <div className="alert alert-info" style={{display: 'inline-block'}}>Needs development.</div>
      </div>
    );
  }
}

export { Setup }
