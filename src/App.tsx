import React from "react"

// Apollo dependencies
import { ApolloClient, HttpLink, InMemoryCache} from "@apollo/client";
import { ApolloProvider } from "@apollo/client/react";

import Weather from "./components/Weather"

// Create Apollo client
const client = new ApolloClient({
  link: new HttpLink({ uri: "http://localhost:3000/graphql"}), // backend GraphQL endpoint
  cache: new InMemoryCache(),
})

const App: React.FC = () => {
  return (
    // Wrap the app with ApolloProvider
    <ApolloProvider client = {client}>
      <div className = "app">
        <Weather/>
    </div>
    </ApolloProvider>

  )
}


export default App
