import { useEffect, useState, useCallback } from "react";
import Web3 from "web3";
import "./App.css";

import detectEthereumProvider from "@metamask/detect-provider";
import { loadContract } from "./utils/load-contract";

function App() {

  const [web3Api, setWeb3Api] = useState({
    provider: null,
    web3: null,
    contract: null
  });

  const [balance, setBalance] = useState(null);
  const [account, setAccount] = useState(null);
  const [shouldReload, reload] = useState(false);

  const reloadEffect = useCallback(() => reload(!shouldReload), [shouldReload]);

  // Listener for every time that you change of account on the metamask
  // this listener will be activated
  const setAccountListener = (provider) => {
    // https://docs.metamask.io/guide/ethereum-provider.html#events
    provider.on("accountsChanged", (accounts) => setAccount(accounts[0]));
  }

  // use effect will be used once time when the component is loaded
  useEffect(() => {
    const loadProvider = async () => {
      // with metamask we have an access to window.ethereum & to window.web3
      // metamask injects a global API into website
      // this API allows websites to request users, accounts, read data to blockchain
      // sign messages and transactions

      console.log(window.web3);
      console.log(window.ethereum);

      const provider = await detectEthereumProvider();
      const { contract } = await loadContract("Faucet", provider);

      if (provider) {
        setAccountListener(provider);
        setWeb3Api({
          web3: new Web3(provider),
          provider,
          contract
        })
      } else {
        console.error("Please, install Metamask");
      }
    }

    loadProvider();
  }, []);

  useEffect(() => {
    const loadBalance = async () => {
      console.log(web3Api);
      const { contract, web3 } = web3Api;
      // https://web3js.readthedocs.io/en/v1.2.11/web3-eth.html#getbalance
      const balance = await web3.eth.getBalance(contract._address);
      // https://web3js.readthedocs.io/en/v1.2.11/web3-utils.html#fromwei
      setBalance(web3.utils.fromWei(balance, 'ether'));
    }

    web3Api.contract && loadBalance();
    // every time that web3Api or shouldReload changes, this effect will be activated
  }, [web3Api, shouldReload]);

  useEffect(() => {
    const getAccounts = async () => {
      const accounts = await web3Api.web3.eth.getAccounts();
      setAccount(accounts[0]);
    };

    // Execute only if web3Api.web3 is defined
    web3Api.web3 && getAccounts();
  }, [web3Api.web3]);

  // We use the useCallback to recreate the function every time
  //  that the value of the dependencies change.
  const addFunds = useCallback(async () => {
    const { contract, web3 } = web3Api;
    // The contract object has their methods on the dictionary methods,
    // also, we should select the function and call the send method passing
    //  the correct argument.
    await contract.methods.addFunds().send({
      from: account,
      value: web3.utils.toWei('1', 'ether')
    });
    // this activates the reload of the current eth from the smart contract
    //  chaning the value of shouldReload and activating the loadBalance effect 
    reloadEffect();
  }, [web3Api, account, reloadEffect]);

  const withdraw = async () => {
    const { contract, web3 } = web3Api;
    const withdrawAmount = web3.utils.toWei('0.099', 'ether');
    // If you have arguments on your smart contract method,
    // you should specify on the method call with the same same from the contract method.
    await contract.methods.withdraw(withdrawAmount).send({
      from: account,
    });
    reloadEffect();
  }


  return (
    <div className="faucet-wrapper">
      <div className="faucet">
        <div className="is-flex is-align-items-center">
          <span>
            <strong className="mr-2">Account: </strong>
          </span>
          { account ? 
            <span>{ account }</span> :  
            <button 
              className="button mt-2 mb-2"
              onClick={() => web3Api.provider.request({method: "eth_requestAccounts"})}
            >
              Connect Wallet
            </button> }
        </div>
        <div className="balance-view is-size-2 my-4">
          Current Balance: <strong>{ balance }</strong> ETH
        </div>
        <button 
          className="button is-link mr-2"
          onClick={addFunds}
        >Donate 1 ether</button>
        <button 
          onClick={withdraw}
          className="button is-primary"
        >Withdraw</button>
      </div>
    </div>
  );
}

export default App;
