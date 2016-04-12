this.Garages = React.createClass({
  getInitialState: function() {
    return {
      garages: this.props.data
    };
  },

  addCar: function(car) {
    garages = this.state.garages.slice();
    garages.push(car);
    this.setState({garages: garages});
  },

  deleteCar: function(car) {
    console.log("hey");
  },

  render: function() {
    var el = this;

    return (
      <div className='garages'>
        <h2 className='name'>Garages</h2>
        <div className='row'></div>
        <GarageForm handleNewCar={this.addCar} />
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
            return <Garage car={car} key={i} handleDeleteCar={el.deleteCar} />
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

  handleSubmit: function(e) {

    var request = $.ajax({
      method: 'POST',
      url: "/garages",
      dataType: 'JSON',
      data: {garage: this.state}
    });

    // An arrow function expression lexically binds the 'this' value. Arrow fxns are anonymous
    request.done( (data) => {
      this.props.handleNewCar(data);
      this.setState(this.getInitialState());
    });

  },

  render: function() {
    return (
      <form className='form-inline' onSubmit={this.handleSubmit}>
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
        <button type='submit' className='btn btn-primary'>Create record</button>
        </div>
      </form>
    )
  }
})

this.Garage = React.createClass({
  getInitialState: function() {
    return null;
  }, 

  handleDelete: function(e) {
    e.preventDefault();
    var request = $.ajax({
      method: 'DELETE',
      url: "/garages/" + this.props.car.id,
      dataType: 'JSON'
    });

    console.log(request);

    request.done( () => {
      this.props.handleDeleteCar(this.props.car)
    });

  },

  garageRow: function() {
    return (
      <tr>
        <td> {this.props.car.name} </td>
        <td> {this.props.car.car_type} </td>
        <td> {this.props.car.year} </td>
        <td> <a className="btn btn-danger" onClick={this.handleDelete}>Delete</a>
        </td>
      </tr>
    )
  },

  render: function() {
    return this.garageRow();
  }
})

