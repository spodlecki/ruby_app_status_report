import React, {Component} from 'react';
import PropTypes from 'prop-types';

const GemLink = (props) => {
  let url = 'https://rubygems.org/gems/' + props.name;
  return (
    <a href={url} target="_blank">
      <strong>{props.name}</strong> - <i>{props.versions.slice(0, 2).join(', ')}</i>
    </a>
  )
}

const ActiveGems = (props) => {
  let groups    = {};
  let headers   = {};
  function renderGemGroups(headers, groups) {
    return headers.map(title => {
      let list = [];
      list.push(<li className="title">{title}</li>)
      groups[title].forEach(function(gem) {
        list.push(<li><GemLink {...gem} /></li>);
      });
      return list;
    });
  }

  props.gems.forEach(function(gem) {
    let initial = gem.name[0];
    if(!groups[initial]) {
      groups[initial] = [];
    }
    groups[initial].push(gem);
  });

  headers = Object.keys(groups);

  return (
    <div className="well well-sm">
      <ul className="list-unstyled">
        {renderGemGroups(headers, groups)}
      </ul>
    </div>
  )
}

const InactiveGems = (props) => {
  if (props.gems.count == 0) {
    return <div></div>
  }


  return (
    <div className="alert alert-warning">
      <p className="lead">You may be hosting these gems on a private server, we could not gather the version information from rubygems.</p>
      <ul className="list-unstyled">
        {props.gems.map((gem, idx) => <li key={idx.toString()}><GemLink {...gem} /></li>)}
      </ul>
    </div>
  )
}

// updated_at, versions
class Gems extends Component {
  static propTypes = { }
  static defaultProps = { }

  constructor(props) {
    super(props);
    this.state = { gems: [] };
  }

  componentDidMount() {
    // setup
    let options = { credentials: 'include' };
    fetch('/ruby_gem_data', options)
      .then(function(response) {
        let contentType = response.headers.get('content-type');
        if(contentType && contentType.includes('application/json')) {
          return response.json();
        }
        throw new TypeError('Response was not JSON.');
      })
      .then(json => {
        this.setState({gems: json});
      })
      .catch(function(error) {
        console.log(error);
      });
  }

  componentWillUnmount() {
    // any teardown
  }

  render() {
    let active    = [];
    let inactive  = [];

    active    = this.state.gems.filter(gem => gem.skip == false)
    inactive  = this.state.gems.filter(gem => gem.skip)

    /* Building active gems list. */

    /* Inactive gems list. */
    return (
      <div id="GemsScreen">
        <h1>Ruby Gems <small>{this.state.gems.length} gems on file.</small></h1>
        <ActiveGems gems={active} />
        <InactiveGems gems={inactive} />
      </div>
    );
  }
}

export { Gems }
