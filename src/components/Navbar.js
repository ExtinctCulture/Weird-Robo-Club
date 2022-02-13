import React, { Component } from 'react';
const Navbar = () => {
    return ( 
        <nav className="navbar">
            <h1>Weird Robo Club</h1>
            <div className="links">
                <a href="/create" style={{ 
                    color:"white",
                    backgroundColor:'#f1356d',
                    borderRadius: '8px',
            }}>New</a>
            </div>
        </nav>
     );
}
 
export default Navbar;