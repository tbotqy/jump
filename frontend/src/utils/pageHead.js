const serviceName = process.env.REACT_APP_SERVICE_NAME;
const suffix = `- ${serviceName}`;

export const PAGE_TITLE_TOP               = `クリックひとつで、過去のあの日のツイートへ ${suffix}`;
export const PAGE_TITLE_TERMS_AND_PRIVACY = `利用規約 プライバシーポリシー ${suffix}`;
export const PAGE_TITLE_IMPORT            = `データのインポート ${suffix}`;
export const PAGE_TITLE_DATA_MANAGEMENT   = `データ管理 ${suffix}`;
export const PAGE_TITLE_NOT_FOUND         = `ページが見つかりませんでした ${suffix}`;
export const TOP_DESCRIPTION = process.env.REACT_APP_META_DESCRIPTION;
