// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract  WeirdRoboClub is  ERC721URIStorage, ERC721Enumerable, Ownable, Pausable {

    //Number of tokens/sale
    uint public og_MAX_Tokens = 50;
    uint public wl_MAX_Tokens = 1888;
    uint public gl_MAX_Tokens = 3888;
    uint public g_MAX_Tokens = 8888;

    //Price of token/sale
    uint public og_price = 0.05 ether;
    uint public wl_price = 0.1 ether;
    uint public gl_price = 0.2 ether;
    uint public g_price = 0.3 ether;


    //Pre Sale Arrays
    mapping(address => bool) public _allowedWL;
    mapping(address => bool) public _allowedOG;
    mapping(address => bool) public _allowedGL;

    //Sale State

    bool public ogIsActive = true;
    bool public wlIsActive = false;
    bool public glIsActive= false;
    bool public gIsActive = false;

    string private baseURI = "";

    constructor() payable ERC721("Weird Robo Club", "WRC"){}   

    //Set Arrays

    function setOG(address[] calldata addresses)
    public
    onlyOwner{
        for (uint256 i = 0; i < addresses.length; i++) {
        _allowedOG[addresses[i]]=true;
        }
    }
    
    function setWL(address[] calldata addresses)
    public
    onlyOwner{
        for (uint256 i = 0; i < addresses.length; i++) {
        _allowedWL[addresses[i]]=true;
        }
    }

    function setGL(address[] calldata addresses)
    public
    onlyOwner{
        for (uint256 i = 0; i < addresses.length; i++) {
        _allowedGL[addresses[i]]=true;
        }
    }


    //Set Sale State

    function SetOGState(bool _ogIsActive) 
    public 
    onlyOwner {
       ogIsActive = _ogIsActive;
    }

    function SetWLState(bool _wlIsActive) 
    public 
    onlyOwner {
       wlIsActive = _wlIsActive;
    }

    function SetGLState(bool _glIsActive) 
    public 
    onlyOwner {
       glIsActive = _glIsActive;
    }

    function SetGState(bool _gIsActive) 
    public 
    onlyOwner {
       gIsActive = _gIsActive;
    }

    //MINT 

    //OG MINT
    function mintOG()
    public
    payable{
        uint256 ts = totalSupply();
        require(ogIsActive, "General Sale Mint is not available");
        require(balanceOf(msg.sender) == 0, "Only One Weird Robo per OG User");
        require(_allowedOG[msg.sender], "This wallet doesn't belong to an OG user");
        require(og_price  <= msg.value, "The amount of Ether sent on transaction is not correct");
        require(msg.sender == tx.origin, "Can only mint through a wallet");
        require(ts + 1 <= og_MAX_Tokens, "This transaction exceeds the maximum number of Warriors on OG sale");
        _safeMint(msg.sender, ts + 1);
    }

    //WL MINT

    function mintWL(uint8 numberOfTokens)
    public
    payable{
        uint256 ts = totalSupply();
        require(wlIsActive, "General Sale Mint is not available");
        require(balanceOf(msg.sender) + numberOfTokens <= 20, "Only 20 Weird Robo per User");
        require(_allowedWL[msg.sender], "This wallet doesn't belong to a WL user");
        require(wl_price * numberOfTokens <= msg.value, "The amount of Ether sent on transaction is not correct");
        require(msg.sender == tx.origin, "Can only mint through a wallet");
        require(ts + numberOfTokens <= og_MAX_Tokens, "This transaction exceeds the maximum number of Warriors on OG sale");
        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, ts + i);
        }
    }

    //GL MINT 

    function mintGL(uint8 numberOfTokens)
    public
    payable{
        uint256 ts = totalSupply();
        require(glIsActive, "General Sale Mint is not available");
        require(balanceOf(msg.sender) + numberOfTokens <= 20, "Only 20 Weird Robo per User");
        require(_allowedGL[msg.sender], "This wallet doesn't belong to a GL user");
        require(gl_price * numberOfTokens <= msg.value, "The amount of Ether sent on transaction is not correct");
        require(msg.sender == tx.origin, "Can only mint through a wallet");
        require(ts + numberOfTokens <= gl_MAX_Tokens, "This transaction exceeds the maximum number of Warriors on OG sale");
        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, ts + i);
        }
    }


    //GENERAL MINT

    function mintG(uint8 numberOfTokens)
    public
    payable{
        uint256 ts = totalSupply();
        require(gIsActive, "General Sale Mint is not available");
        require(balanceOf(msg.sender) + numberOfTokens <= 20, "Only 20 Weird Robo per User");
        require(g_price * numberOfTokens <= msg.value, "The amount of Ether sent on transaction is not correct");
        require(msg.sender == tx.origin, "Can only mint through a wallet");
        require(ts + numberOfTokens <= g_MAX_Tokens, "This transaction exceeds the maximum number of Warriors on OG sale");
        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, ts + i);
        }
    }



    //Airdrops and Creator Team Mint 
    function mint_primary_admin(address address_, uint256 numberOfTokens)
    public
    onlyOwner {
        uint256 ts = totalSupply();
        require(ts + numberOfTokens <= g_MAX_Tokens, "This transaction exceeds the maximum number of Robos on sale"); 
        for(uint256 i = 0; i < numberOfTokens; i++) {                                 
            _safeMint(address_, ts+i);
        }   
    }

    // pause minting and merging
    function pause() 
    public 
    onlyOwner {
        _pause();
    }
    
    // unpause minting and merging 
    function unpause()
    public 
    onlyOwner {
        _unpause();
    }

    function checkContractBalance()    
    public
    view
    onlyOwner
    returns (uint256){
        return address(this).balance;
    }
       
    function withdraw()
    public
    payable
    onlyOwner{
        payable(msg.sender).transfer(address(this).balance);
    }
    
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    override(ERC721, ERC721Enumerable){
        super._beforeTokenTransfer(from, to, tokenId);
    }
    
    function _burn(uint256 tokenId)
    internal 
    onlyOwner
    override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
    
    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable)
    returns (bool){
        return super.supportsInterface(interfaceId);
    }
    
    
    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory){
        return super.tokenURI(tokenId);
    }

    // Base URI Config
    function change_base_URI(string memory new_base_URI)
    onlyOwner
    public{
        baseURI = new_base_URI;
    }

    function _baseURI() 
    internal 
    view 
    override 
    returns (string memory) {
        return baseURI;
    }    

}