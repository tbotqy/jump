import axios from "axios";
axios.defaults.withCredentials = true;

export const API_NORMAL_CODE_OK               = 200;
export const API_NORMAL_CODE_ACCEPTED         = 202;
export const API_ERROR_CODE_TOO_MANY_REQUESTS = 429;

const apiOrigin = process.env.REACT_APP_API_ORIGIN;

const api = {
  get: (path, params = {}) => {
    return axios.get(apiOrigin + path, { params: params });
  },
  post: (path, params = {}) => {
    return axios.post(apiOrigin + path, { params });
  },
  put: path => {
    return axios.put(apiOrigin + path);
  }
};

export default api;
