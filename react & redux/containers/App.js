import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import * as actions from '../actions'

class App extends React.Component {
  constructor() {
    super()
    window.inc = 1
  }

  addGame() {
    this.props.actions.addGame({
      name: `Nova hra nb. ${window.inc++}`
    })
  }

  render() {
    console.log(this.props);
    return(
      <div onClick={this.addGame.bind(this)}>test app</div>
    )
  }
}

App.propTypes = {
  games: PropTypes.array.isRequired
}

const mapStateToProps = state => ({
  games: state.games
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(actions, dispatch)
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(App)
