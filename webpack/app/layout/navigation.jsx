import React, {Component} from 'react';
import PropTypes from 'prop-types'
import { FontIcon } from 'app/components/font_icon'
import { NavLink as Link } from 'react-router-dom'

const navItem = (name, route, icon, children=[]) => {
  let base = {
    name:     name,
    route:    route
  }
  if (icon) { base['icon'] = icon; }
  if (children.length > 0) { base['children'] = children; }
  return base;
}

const RenderNavItemFromMap = (item, index) => {
  return <NavItemHtml key={index.toString()} {...item}/>
}

class NavItemHtml extends Component {
  static propTypes = {
    name:     PropTypes.string.isRequired,
    route:    PropTypes.string.isRequired,
    icon:     PropTypes.string,
    children: PropTypes.array
  }

  render() {
    let cssClasses, icon, children;

    cssClasses = this.props.children ? 'submenu' : '';

    if (this.props.icon) {
      icon = <FontIcon icon={this.props.icon} />
    }
    return (
      <li>
        <Link to={this.props.route} className={cssClasses} activeClassName="active">
          {icon} {this.props.name}
        </Link>
        {this.renderChildrenItems()}
      </li>
    )
  }

  renderChildrenItems() {
    if (this.props.children && this.props.children.length > 0) {
      <ul>
        {this.props.children.map(RenderNavItemFromMap)}
      </ul>
    }
  }
}

class Navigation extends Component {
  static propTypes = {
    navItems: PropTypes.array.isRequired
  }

  render() {
    return (
      <nav id="admin-nav">
        <h1>
          <FontIcon icon="diamond"/> Application <small>Status</small>
        </h1>
        <ul>
          {this.props.navItems.map(RenderNavItemFromMap)}
        </ul>
      </nav>
    );
  }
}

export { Navigation, navItem }
