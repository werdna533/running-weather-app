// weather.ts
import { gql } from "@apollo/client";

export const SAVE_USER_PREFERENCES = gql`
  mutation SaveUserPreferences($input: SaveUserPreferencesInput!) {
    saveUserPreferences(input: $input) {
      user {
        uuid
        runPreferences {
          city
          duration
          skinType
        }
      }
    }
  }
`;

export const FETCH_USER_PREFERENCES = gql`
  query FetchUserPreferences($userId: ID!) {
    fetchUserPreferences(userId: $userId) {
      uuid
      latestRunPreference {
        city
        duration
        skinType
      }
    }
  }
`;
