import React from "react";
import {
  Chip,
  CircularProgress
} from "@material-ui/core";
import { fetchStats, Stats } from "../api";

interface State {
  stats?: Stats;
}

class StatsChip extends React.Component<{}, State> {
  state = { stats: undefined }

  async componentDidMount() {
    const response = await fetchStats();
    this.setState({ stats: response.data });
  }

  render() {
    const { stats } = this.state;
    if (stats) {
      const { statusCount, userCount } = stats as unknown as Stats;
      return <Chip label={`${statusCount} ツイート / ${userCount} ユーザー`} />;
    } else {
      return <CircularProgress size={24} />;
    }
  }
}

export default StatsChip;
