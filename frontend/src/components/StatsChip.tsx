import React, { useEffect, useState } from "react";
import { Chip, CircularProgress } from "@material-ui/core";
import { fetchStats, Stats } from "../api";

const StatsChip: React.FC = () => {
  const [stats, setStats] = useState<Stats | undefined>(undefined);

  useEffect(() => {
    (async() => {
      const response = await fetchStats();
      setStats(response.data);
    })();
  }, []);

  if (stats) {
    const { statusCount, userCount } = stats;
    return <Chip label={`${statusCount} ツイート / ${userCount} ユーザー`} />;
  } else {
    return <CircularProgress size={24} />;
  }
};

export default StatsChip;
