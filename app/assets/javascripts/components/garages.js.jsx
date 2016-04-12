this.Garages = React.createClass({
  getInitialState: function() {
    return {
      garages: this.props.data
    };
  },

  getDefaultProps: function() {
    return { garages: [] };
  },

  updateCar: function(car, data) {
    index = this.state.garages.indexOf(car);
    garages = React.addons.update(this.state.garages, { $splice: [[index, 1, data]] });
    this.replaceState({ garages: garages });
  },

  addCar: function(car) {
    garages = this.state.garages.slice();
    garages.push(car);
    this.setState({garages: garages});
  },

  deleteCar: function(car) {
    index = this.state.garages.indexOf(car);
    garages = React.addons.update(this.state.garages, { $splice: [[index, 1]] });
    this.replaceState({ garages: garages });
  },

  render: function() {
    var el = this;
    var items = this.state.garages;

    return (
      <div className='garages'>
        <h2 className='name'>Garage</h2>
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
          {items.map(function(car, i) {
            return <Garage car={car} key={i} handleDeleteCar={el.deleteCar} handleEditCar={el.updateCar} />
          })}
          </tbody>
        </table>
      </div>
    )
  }

})


// =====// =====// =====// =====// =====// =====// =====// =====// =====// =====// =====// =====


this.GarageForm = React.createClass({
  getInitialState: function() {
    return { name: '', car_type: '', year: ''};
  },

  valid: function() {
    return this.state.name && this.state.car_type && this.state.year
  },

  handleChange: function(e) {
    var change = {};
    var targetName = e.target.name;
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
        <button type='submit' className='btn btn-primary' disabled={!this.valid()}>Add Car</button>
        </div>
      </form>
    )
  }
})


// ===== // =====// =====// =====// =====// =====// =====// =====// =====// =====


this.Garage = React.createClass({
  getInitialState: function() {
    return { edit: false }
  },

  handleToggle: function(e) {
    e.preventDefault();
    this.setState({edit: !this.state.edit })
  },

  handleDelete: function(e) {
    e.preventDefault();
    var request = $.ajax({
      method: 'DELETE',
      url: "/garages/" + this.props.car.id,
      dataType: 'JSON'
    });

    request.done( () => {
      this.props.handleDeleteCar(this.props.car)
    });

  },

  handleEdit: function(e) {
    e.preventDefault();
    var data = {
      name: ReactDOM.findDOMNode(this.refs.name).value,
      car_type: ReactDOM.findDOMNode(this.refs.car_type).value,
      year: ReactDOM.findDOMNode(this.refs.year).value
    }
    var request = $.ajax({
      method: "PUT",
      url: "/garages/" + this.props.car.id,
      dataType: "JSON",
      data: { garage: data }
    });

    request.done( (data) => {
      this.setState({ edit: false });
      this.props.handleEditCar(this.props.car, data);
    })
  },

  garageForm: function() {
    return (
      <tr>
        <td>
          <input className="form-control" type="text" defaultValue={this.props.car.name} ref="name" />
        </td>
        <td>
          <input className="form-control" type="text" defaultValue={this.props.car.car_type} ref="car_type" />
        </td>
        <td>
          <input className="form-control" type="number" defaultValue={this.props.car.year} ref="year" />
        </td>
        <td>
          <a className="btn btn-default" onClick={this.handleEdit}>Update</a>
          <a className="btn btn-danger" onClick={this.handleToggle}>Cancel</a>
        </td>
      </tr>
    )
  },

  garageRow: function() {
    return (
      <tr>
        <td> {this.props.car.name} </td>
        <td> {this.props.car.car_type} </td>
        <td> {this.props.car.year} </td>
        <td>
          <a className="btn btn-default" onClick={this.handleToggle}>Edit</a>
          <a className="btn btn-danger" onClick={this.handleDelete}>Delete</a>
        </td>
      </tr>
    )
  },

  render: function() {
    if (this.state.edit) {
      return this.garageForm();
    } else {
      return this.garageRow();
    }
  }
})

