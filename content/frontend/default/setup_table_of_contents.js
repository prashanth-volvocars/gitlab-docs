import Vue from 'vue';
import TableOfContents from './components/table_of_contents.vue';
import StickToFooter from './directives/stick_to_footer';
import { parseTOC } from '../shared/toc/parse_toc';

const SIDEBAR_SELECTOR = 'doc-nav';
const MARKDOWN_TOC_ID = 'markdown-toc';
const HELP_AND_FEEDBACK_ID = 'help-and-feedback';
const MAIN_SELECTOR = '.js-main-wrapper';

export default () => {
  const sidebar = document.getElementById(SIDEBAR_SELECTOR);
  const menu = document.getElementById(MARKDOWN_TOC_ID);
  const main = document.querySelector(MAIN_SELECTOR);
  const hasHelpAndFeedback = Boolean(document.getElementById(HELP_AND_FEEDBACK_ID));

  if (!sidebar || !menu) {
    return null;
  }

  if (main) {
    main.classList.add('has-toc');
  }

  const items = parseTOC(menu);
  menu.remove();

  const el = document.createElement('div');
  sidebar.appendChild(el);

  return new Vue({
    el,
    directives: {
      StickToFooter,
    },
    render(h) {
      return h(TableOfContents, {
        props: {
          items,
          helpAndFeedbackId: HELP_AND_FEEDBACK_ID,
          hasHelpAndFeedback,
        },
        directives: [
          {
            name: 'stick-to-footer',
            value: MAIN_SELECTOR,
            expression: MAIN_SELECTOR,
          },
        ],
      });
    },
  });
};
