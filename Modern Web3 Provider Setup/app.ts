import { http, createConfig, WagmiProvider } from 'wagmi'
import { mainnet, sepolia } from 'wagmi/chains'
import { walletConnect, injected } from 'wagmi/connectors'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

// 1. Setup the QueryClient (Wagmi heavily relies on React Query for caching)
const queryClient = new QueryClient()

// 2. Create the strict, type-safe Wagmi config
const projectId = process.env.NEXT_PUBLIC_WC_PROJECT_ID!

export const config = createConfig({
  chains: [mainnet, sepolia],
  connectors: [
    injected(), // Supports standard browser extensions like MetaMask
    walletConnect({ projectId }), // Supports Mobile QR code scanning
  ],
  transports: {
    [mainnet.id]: http(),
    [sepolia.id]: http(),
  },
})

// 3. Wrap your Next.js application in the Providers
export function Web3Provider({ children }: { children: React.ReactNode }) {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        {children}
      </QueryClientProvider>
    </WagmiProvider>
  )
}