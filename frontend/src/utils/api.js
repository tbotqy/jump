import axios from "axios";
axios.defaults.withCredentials = true;

const apiOrigin = process.env.REACT_APP_API_ORIGIN;

const api = {
  get: (path, params = {}) => {
    return axios.get(apiOrigin + path, { params: params });
  }
};

export default api;
