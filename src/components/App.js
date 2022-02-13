//Import React Library
import React, { Component } from 'react';
import './App.css';
import Navbar from './Navbar';
import Home from './Home';
import Mint from './Mint';
//class App extends Component {

function App(){
        return(       
            <div className="App">
                <Navbar />
                <Home />
                <Mint/>
            </div>
        );        
}

export default App;