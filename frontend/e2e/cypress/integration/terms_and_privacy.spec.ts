/// <reference types="Cypress" />

describe("/terms_and_privacy", () => {
  beforeEach(() => {
    cy.visit("/terms_and_privacy");
  });

  describe("1st section", () => {
    describe("header", () => {
      it("", () => {
        cy.get("h4").first().should("have.text", "利用規約");
      });
    });
    describe("list items", () => {
      it("", () => {
        cy.get("h4").contains("利用規約").next().children() // li tags
          .first()
          .should("have.text", "このアプリケーションでは、Twitter が提供している仕組みを利用して、ユーザーが Twitter で保有しているデータを取得・保存します。")
          .next()
          .should("have.text", "保存されたあなたのツイートは、アプリケーション内の パブリックタイムライン に表示され、誰でも見ることが可能となります。(非公開アカウントのツイートは表示されません。)")
          .next()
          .should("have.text", "取得できるツイートの件数は、最新のツイートから最大 3,200 件までです。")
          .next()
          .should("have.text", "当サービスは、表示データの正確性確保に努めますが、これを保証するものではありません。")
          .next()
          .should("have.text", "当サービスは、当サービスを利用することにより発生したいかなる損害も、責任を負わないものとします。")
          .next()
          .should("have.text", "当サービスの提供は予告無く停止・変更される場合がある事を予めご了承ください。");
      });
      it("2nd item has a valid link to the public timeline", () => {
        cy.get("h4").contains("利用規約").next().children().eq(1).find("a").click();
        cy.url().should("include", "/public_timeline");
      });
    });
  });

  describe("2nd section", () => {
    describe("header", () => {
      it("", () => {
        cy.get("h4").last().should("have.text", "プライバシーポリシー");
      });
    });
    describe("list items", () => {
      it("", () => {
        cy.get("h4").contains("プライバシーポリシー").next().children() // li tags
          .first()
          .should("have.text", "ユーザーのデータの取り扱いについて")
          .should("have.class", "MuiListSubheader-root")
          .next()
          .should("have.text", "当サービスがユーザーに提供する機能の実現にのみ利用します。")
          .next()
          .should("have.text", "ユーザーの操作により、好きな時に削除する事ができます。")
          .next()
          .should("have.text", "広告配信に際して")
          .should("have.class", "MuiListSubheader-root")
          .next()
          .should("have.text", "当サービスでは、Google が提供する広告サービス「Google アドセンス」を利用しています。")
          .next()
          .should("have.text", "Google アドセンス では、ユーザーの興味に基づいた広告の表示をするため、当サイトや他サイトへのアクセスに関する情報 （Cookie）を使用することがあります。")
          .next()
          .should("have.text", "Cookie を無効にする設定および Google アドセンス に関する詳細はこちら をご覧ください。")
          .next()
          .should("have.text", "アクセス解析に際して")
          .should("have.class", "MuiListSubheader-root")
          .next()
          .should("have.text", "当サービスでは、サイトの利用状況の分析と改善の目的で、Google が提供するアクセス解析ツール「Google アナリティクス」を利用しています。")
          .next()
          .should("have.text", "Google アナリティクス では、トラフィックデータの収集のために、Cookie を使用しています。")
          .next()
          .should("have.text", "このトラフィックデータには、個人を特定する情報は含まれません。")
          .next()
          .should("have.text", "Cookie を無効にすることでトラフィックデータの収集を拒否することができます。お使いのブラウザの設定をご確認ください。")
          .next()
          .should("have.text", "Google の Cookie の利用に関する詳細は、こちら をご覧ください。");
      });
      describe("links", () => {
        it("", () => {
          cy.contains("Cookie を無効にする設定および Google アドセンス に関する詳細はこちら をご覧ください。")
            .find("a")
            .should("have.attr", "target", "_blank")
            .should("have.prop", "href")
            .and("eq", "https://policies.google.com/technologies/ads?hl=ja");
          cy.contains("Google の Cookie の利用に関する詳細は、こちら をご覧ください。")
            .find("a")
            .should("have.attr", "target", "_blank")
            .should("have.prop", "href")
            .and("eq", "https://policies.google.com/technologies/partner-sites?hl=ja");
        });
      });
    });
  });
});
