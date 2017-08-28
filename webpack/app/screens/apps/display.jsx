import React, {Component} from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom'
import { FontIcon } from 'app/components/font_icon'
import { ItemBox } from 'app/components/item_box'

class AppDisplay extends Component {
  static propTypes = { }
  static defaultProps = { }

  constructor(props) {
    super(props);
    this.state = {
      name: null,
      items: [],
      updated_at: null,
      status: false
    };
  }

  componentDidMount() {
    let id = this.props.match.params.id;
    let options = { credentials: 'include' };
    fetch('/ruby_apps/' + id, options)
      .then(function(response) {
        let contentType = response.headers.get('content-type');
        if(contentType && contentType.includes('application/json')) {
          return response.json();
        }
        throw new TypeError('Response was not JSON.');
      })
      .then(json => {
        let date = new Date(Date.parse(json.updated_at)).toLocaleString('en-US');
        this.setState({
          name: json.name,
          items: json.items,
          status: json.status,
          updated_at: date
        });
      })
      .catch(function(error) {
        console.log(error);
      });
  }

  componentWillUnmount() {
    // any teardown
  }

  renderItem(item, key) {
    return (
      <ItemBox key={key.toString()} {...item} />
    );
  }

  copyToClipboard() {
    let ele = document.querySelector('#app-display textarea');
    ele.style.display = 'block';
    ele.select();
    document.execCommand('copy');
    ele.style.display = 'none';
  }

  downloadFileUrl(content) {
    return "data:text/plain;charset=utf-8," + encodeURIComponent(content);
  }

  /* Builds out text format for printing and clipboard */
  renderTextFormat(items) {
    let notices = {};
    let output = [];

    output.push(this.state.name);
    output.push('--------------------------');
    output.push('--------------------------');

    let gatherSection = function(title, items) {
      let output = [];
      output.push('--------------------------');
      output.push(title);
      output.push('--------------------------');
      output = output.concat(
        items.map(item => {
          return item.name + ': ' + item.version + ' (' + item.note + ')';
        })
      )
      return output;
    }

    notices['Urgent'] = items.filter(item => item.level == 1)
    notices['Updates'] = items.filter(item => [2, 3, 4].indexOf(item.level) > -1)
    notices['None'] = items.filter(item => item.level == 5)

    if (notices['Urgent'].length > 0) {
      output = output.concat(gatherSection('Urgent Updates', notices['Urgent']));
    }
    if (notices['Updates'].length > 0) {
      output = output.concat(gatherSection('Updates', notices['Updates']));
    }
    if (notices['None'].length > 0) {
      output = output.concat(gatherSection('Up to date gems', notices['None']));
    }
    return output.join("\n");
  }

  render() {
    let items = [];
    let filename = 'ruby-app.txt';
    let textContent = '';
    let alert = this.state.status ? '' : <div className="alert alert-info">We still have not collected data for this app.</div>;

    if (this.state.items && this.state.items.length > 0) {
      items = this.state.items.sort(function(a,b) {
        return parseInt(a.level) - parseInt(b.level);
      });
      textContent = this.renderTextFormat(items);
    }

    return (
      <div id="app-display">
        <Link to="/" className="close"><FontIcon icon="close" /></Link>
        <h1>
          {this.state.name}
          <small> Last Sync: {this.state.updated_at}</small>
        </h1>

        <div className="btn-group">
          <button className="btn btn-md btn-default" onClick={() => window.print()}>
            <FontIcon icon="print" />
          </button>
          <button className="btn btn-md btn-default" onClick={this.copyToClipboard}>
            <FontIcon icon="clipboard" />
          </button>
          <a className="btn btn-md btn-default" href={this.downloadFileUrl(textContent)} download={filename}>
            <FontIcon icon="download" />
          </a>
        </div>

        <div id="app-display-items">
          {alert}
          {items.map(this.renderItem)}
        </div>
        <textarea style={{display: 'none'}} value={textContent}></textarea>
      </div>
    )
  }
}

export { AppDisplay }
