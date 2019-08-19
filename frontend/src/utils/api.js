import axios from "axios";

const apiOrigin = process.env.REACT_APP_API_ORIGIN;

const api = {
  get: (path, params = {}) => {
    return axios.get(apiOrigin + path, { params: params });
  }
};

export default api;
