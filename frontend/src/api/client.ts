import axios, { AxiosResponse } from "axios";
import store from "../store/index";
import { setApiErrorCode } from "../store/api_error/actions";

axios.defaults.withCredentials = true;
axios.defaults.headers["X-Requested-With"] = "XMLHttpRequest";
axios.defaults.baseURL = process.env.REACT_APP_API_ORIGIN;

const onSuccess = (response: AxiosResponse) => response;

const onFailure = (error: any) => {
  if (error.response) {
    store.dispatch(setApiErrorCode(error.response));
  }
  Promise.reject(error);
};

axios.interceptors.response.use(onSuccess, onFailure);

export default axios;
