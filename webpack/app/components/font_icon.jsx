import React, {Component} from 'react';
import PropTypes from 'prop-types'

class FontIcon extends Component {

  static propTypes = {
    icon: PropTypes.string.isRequired
  }

  render() {
    let className = 'fa fa-' + this.props.icon;

    return (
      <i className={className}></i>
    );
  }
}

export { FontIcon }
