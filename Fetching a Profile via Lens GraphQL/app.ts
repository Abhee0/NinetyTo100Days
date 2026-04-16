import { ApolloClient, InMemoryCache, gql } from '@apollo/client'

const API_URL = 'https://api.lens.dev'

const client = new ApolloClient({
  uri: API_URL,
  cache: new InMemoryCache(),
})

// The query to get a profile by its unique handle
const GET_PROFILE = gql`
  query Profile($handle: Handle!) {
    profile(request: { handle: $handle }) {
      id
      name
      bio
      attributes {
        displayType
        traitType
        key
        value
      }
      stats {
        totalFollowers
        totalFollowing
        totalPosts
      }
      picture {
        ... on MediaSet {
          original {
            url
          }
        }
      }
    }
  }
`

async function fetchLensProfile(handle: string) {
  const response = await client.query({
    query: GET_PROFILE,
    variables: { handle },
  })
  console.log('Lens Profile Data:', response.data.profile)
}

fetchLensProfile('stani.lens')