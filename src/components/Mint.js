import React, { useState, Component }  from 'react';
import Web3 from 'web3'
import WeirdRoboClub from '../abis/WeirdRoboClub.json'
import './App.css';

class Mint extends Component {


    async loadWeb3(){

        if (window.ethereum) {
          window.web3 = new Web3(window.ethereum)
          await window.ethereum.enable()
        }
        else if (window.web3) {
          window.web3 = new Web3(window.web3.currentProvider)
        }
        else {
          window.alert('Smart Contract Not in Production yet. Stay Tuned. ')
        }
        }
    
    async loadBlockChainData(){

            await this.loadWeb3();

            const web3 = window.web3
            //Grab account from metamask
            const accounts = await web3.eth.getAccounts()
            //set the account to the current state of account variable
            this.setState({ account: accounts[0]})
            //Create Copy of the Contract 
            const abi = WeirdRoboClub.abi
            //Get the network Id of the wallet 
            const networkId = await web3.eth.net.getId()
            //Check if the network id is present on Network Contract
            const NetworkContract = WeirdRoboClub.networks[networkId]		
            //Check if contract is available on the network where metamask is.
            if(NetworkContract){
    
                const address = NetworkContract.address	
                var contract = new web3.eth.Contract(abi, address)
                this.setState({ contract })
                var ActiveSale = await contract.methods.ogIsActive.call()
                this.setState({ActiveSale})
                console.log(ActiveSale)
                var MintedTokens = await contract.methods.totalSupply.call()
                var MintedTokensLeft = 50 - MintedTokens;
                this.setState({ MintedTokensLeft })
            } else { 
    
                window.alert('Smart Contract Not in Production yet. Stay Tuned!')
            }		
        }
    
    mint = (numberOfTokens) => {
            if (this.state.ActiveSale){
                const TransactionCost = 50000000000000000 
                this.state.contract.methods.createToken(numberOfTokens).send({ from: this.state.account, value: TransactionCost*numberOfTokens})
            }
            else{
                alert('A problem has occured. Please try again later.')
            }		
        }
    
    constructor(props) {
        super(props)
        this.state = {
            account: '', 
            contract: null,
            MintedTokens: null,
            MintedTokensLeft: null,
            ActiveSale: null,
            }
        }
    
    render() {	
        return(

            <div>
                <button onClick={()=>  this.loadBlockChainData()}>Connect Your Wallet</button>
                <p>{this.state.account}</p>
            </div>
          );
    } 
}

export default Mint;