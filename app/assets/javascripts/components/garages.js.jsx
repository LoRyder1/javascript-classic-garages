this.Garages = React.createClass({
  getInitialState: function() {
    return {
      garages: this.props.data
    };
  },

  render: function() {
    return (
      <div className='garages'>
        <h2 className='name'>Garages</h2>
        <div className='row'></div>
        <GarageForm />
        <hr></hr>
        <table className='table table-bordered'>
          <thead>
          <tr>
            <th>Name</th>
            <th>Car Type</th>
            <th>Year</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          {this.state.garages.map(function(car, i){
            return <Garage car={car} key={i} />
          })}
          </tbody>
        </table>
      </div>
    )
  }

})

this.GarageForm = React.createClass({
  getInitialState: function() {
    return { name: '', car_type: '', year: ''};
  },

  handleChange: function(e) {
    var change = {};
    targetName = e.target.name;
    change[targetName] = e.target.value;
    this.setState(change);
  },

  render: function() {
    return (
      <form className='form-inline'>
        <div className='form-group'>
          <input type='text' className='form-control' placeholder='Name' name='name'
            value={this.state.name} onChange={this.handleChange} />
        </div>
        <div className='form-group'>
          <input type='text' className='form-control' placeholder='Car Type' name='car_type'
            value={this.state.car_type} onChange={this.handleChange} />
        </div>
        <div className='form-group'>
          <input type='number' className='form-control' placeholder='Year' name='year'
            value={this.state.year} onChange={this.handleChange} />
        </div>
      </form>
    )
  }
})

this.Garage = React.createClass({
  garageRow: function() {
    return (
      <tr>
        <td> {this.props.car.name} </td>
        <td> {this.props.car.car_type} </td>
        <td> {this.props.car.year} </td>
      </tr>
    )
  },

  render: function() {
    return this.garageRow();
  }
})

