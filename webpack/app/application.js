import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import { AppLayout } from 'app/layout/template'

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <AppLayout />,
    document.body.appendChild(document.createElement('div')),
  )
})
