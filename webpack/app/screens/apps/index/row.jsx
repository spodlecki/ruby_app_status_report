import React, {Component} from 'react';
import PropTypes from 'prop-types';
import Slider from 'react-slick';
import { AppTitle } from './title'
import { ItemBox } from 'app/components/item_box'


function percentage(items, selection=[]) {
  let total = items.length;
  let yes = items.filter(item => selection.indexOf(item.level) > -1).length;

  return yes / total * 100;
}

function green(items) {
  return percentage(items, [4, 5]);
}
function yellow(items) {
  return percentage(items, [2, 3]);
}
function red(items) {
  return percentage(items, [1]);
}

class AppRow extends Component {

  static propTypes = {
    name: PropTypes.string.isRequired,
    items: PropTypes.array,
    status: PropTypes.bool
  }

  static defaultProps = {
    items: []
  }

  renderItem(item, key) {
    return (
      <div key={key.toString()}><ItemBox {...item} /></div>
    );
  }

  renderItems() {
    if (this.props.items.length > 0) {
      let items = [];

      items = this.props.items.sort(function(a,b) {
        return parseInt(a.level) - parseInt(b.level);
      });

      return items.map(this.renderItem);
    } else {
      return <div></div>;
    }
  }

  render() {
    let slider_or_alert;
    let settings = {
      dots: false,
      infinite: false,
      speed: 300,
      slidesToScroll: 4,
      responsive: [
        { breakpoint: 10000, settings: { slidesToShow: 8 } },
        { breakpoint: 1599, settings: { slidesToShow: 5 } },
        { breakpoint: 1250, settings: { slidesToShow: 4 } },
        { breakpoint: 1050, settings: { slidesToShow: 3 } },
      ]
    };

    if (this.props.status) {
      slider_or_alert = <Slider {...settings}>{this.renderItems()}</Slider>
    } else {
      slider_or_alert = <div className="alert alert-warning">We will have data for this later...</div>
    }
    return (
      <div className="app">
        <div className="app-title">
          <AppTitle id={this.props.id}
                    name={this.props.name}
                    green={green(this.props.items)}
                    yellow={yellow(this.props.items)}
                    red={red(this.props.items)} />
        </div>
        {slider_or_alert}
      </div>
    );
  }
}

export { AppRow }
