import React, {Component} from 'react';
import PropTypes from 'prop-types';
import Slider from 'react-slick';
import { FontIcon } from 'app/components/font_icon'
import { HashRouter as Router, Route, Link } from 'react-router-dom'

class AppTitle extends Component {

  static propTypes = {
    id: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    green: PropTypes.number.isRequired,
    yellow: PropTypes.number.isRequired,
    red: PropTypes.number.isRequired
  }

  icon() {
    if (this.props.red > 10) {
      return 'bell';
    } else if (this.props.yellow > 35) {
      return 'exclamation-circle';
    } else if (this.props.red == 0 && this.props.yellow < 20) {
      return 'fort-awesome';
    } else {
      return 'thumbs-up-o';
    }
  }
  // <a href={anchor}>{this.props.name}</a>
  render() {
    let anchor = '/apps/' + this.props.id;

    return (
      <div className="app-title">
        <p className="h3">
          <FontIcon icon={this.icon()} />
          <Link to={anchor}>{this.props.name}</Link>
        </p>

        <div className="progress">
          <div className="progress-bar progress-bar-success" style={{width: this.props.green + '%'}}>
            <span className="sr-only">{this.props.green}% good</span>
          </div>
          <div className="progress-bar progress-bar-warning" style={{width: this.props.yellow + '%'}}>
            <span className="sr-only">{this.props.yellow}% bad</span>
          </div>
          <div className="progress-bar progress-bar-danger" style={{width: this.props.red + '%'}}>
            <span className="sr-only">{this.props.red}% ugly</span>
          </div>
        </div>
      </div>
    );
  }
}

export { AppTitle }
