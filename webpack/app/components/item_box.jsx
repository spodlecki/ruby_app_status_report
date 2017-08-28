import React, {Component} from 'react';
import PropTypes from 'prop-types';
import { FontIcon } from 'app/components/font_icon'

class ItemBox extends Component {

  static propTypes = {
    name: PropTypes.string.isRequired,
    version: PropTypes.string.isRequired,
    level: PropTypes.number.isRequired,
    note: PropTypes.string.isRequired
  }

  render() {
    let className = 'item defcon-' + this.props.level;
    let rubygems = 'https://rubygems.org/gems/' + this.props.name;
    return (
      <div className="item-container">
        <div className={className}>
          <FontIcon icon="defcon"/>
          <a href={rubygems} className="item-title" target="_blank">
            {this.props.name}
          </a>
          <p className="item-details">{this.props.version}</p>
          <p className="item-note">{this.props.note}</p>
        </div>
      </div>
    );
  }
}

export { ItemBox }
