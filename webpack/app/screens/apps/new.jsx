import React, {Component} from 'react';
import PropTypes from 'prop-types';
import { FontIcon } from 'app/components/font_icon';
import { Link } from 'react-router-dom';
import { Redirect } from 'react-router'

class AppNew extends Component {
  static propTypes = { }
  static defaultProps = { }

  constructor(props) {
    super(props);
    this.state = {
      id: false,
      name: '',
      repo_url: '',
      api_type: 1,
      gitlab_endpoint: '',
      gitlab_private_token: '',
      errors: []
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentDidMount() {
    // any setup
  }

  componentWillUnmount() {
    // any teardown
  }

  save(form) {
    let options = {
      credentials: 'include',
      method: 'POST',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: new FormData(form)
    };
    // console.log(JSON.stringify(this.state).replace(/{|}/gi, ""))
    fetch('/ruby_apps', options)
      .then(function(response) {
        let contentType = response.headers.get('content-type');
        if(contentType && contentType.includes('application/json')) {
          return response.json();
        }
        throw new TypeError('Response was not JSON.');
      })
      .then(json => {
        if (json.errors.length > 0) {
          this.setState({errors: json.errors});
        } else {
          this.setState(json);
        }
      })
      .catch(function(error) { console.log(error); });
  }

  handleChange(event) {
    const target = event.target;
    const value = target.type === 'checkbox' ? target.checked : target.value;
    const name = target.name;

    this.setState({
      [name]: value
    });
  }

  handleSubmit(event) {
    event.preventDefault();
    this.save(event.currentTarget);
  }

  render() {
    let alerts = '';
    if (this.state.errors.length > 0) {
      alerts = this.state.errors.map((err, idx) => <div key={idx.toString()} className="alert alert-danger">{err}</div>)
    }
    return (
      <div>
        <Link to="/" className="close"><FontIcon icon="close" /></Link>
        <h1>
          New Application
          <small> {this.state.name}</small>
        </h1>
        <form onSubmit={this.handleSubmit} style={{maxWidth: '600px'}}>
          {alerts}
          <div className="form-group">
            <label>App Name</label>
            <input type="text" name="name" className="form-control" placeholder="App name" value={this.state.name} onChange={this.handleChange} />
            <span className="help-block">An identifier for the dashboard</span>
          </div>
          <div className="form-group">
            <label>Git Repo SSH</label>
            <input type="text" name="repo_url" className="form-control" placeholder="git@...." value={this.state.repo_url} onChange={this.handleChange} />
            <span className="help-block">Use the SSH URL.</span>
          </div>
          <input className="btn btn-info" type="submit" value="Save" />
        </form>
        {this.state.id && (
          <Redirect to={'/apps/'+this.state.id}/>
        )}
      </div>
    );
  }
}

export { AppNew }
