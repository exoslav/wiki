import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'

import * as actions from '../actions'

class App extends React.Component {
  render() {
    return(
      <div>test react & redux</div>
    )
  }
}

App.propTypes = {
  list: PropTypes.array.isRequired
}

const mapStateToProps = state => ({
  list: state.list
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(actions, dispatch)
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(App)
