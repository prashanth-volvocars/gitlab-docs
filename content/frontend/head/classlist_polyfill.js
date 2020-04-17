/*
 * classList.js: Cross-browser full element.classList implementation.
 * 1.1.20170427
 *
 * By Eli Grey, http://eligrey.com
 * License: Dedicated to the public domain.
 *   See https://github.com/eligrey/classList.js/blob/master/LICENSE.md
 */

/*! @source http://purl.eligrey.com/github/classList.js/blob/master/classList.js */

if ('document' in window.self) {
  // Full polyfill for browsers with no classList support
  // Including IE < Edge missing SVGElement.classList
  if (
    !('classList' in document.createElement('_')) ||
    (document.createElementNS &&
      !('classList' in document.createElementNS('http://www.w3.org/2000/svg', 'g')))
  ) {
    (view => {
      if (!('Element' in view)) return;

      const classListProp = 'classList';
      const protoProp = 'prototype';
      const elemCtrProto = view.Element[protoProp];
      const objCtr = Object;
      const strTrim = String[protoProp].trim || (() => this.replace(/^\s+|\s+$/g, ''));
      const arrIndexOf =
        Array[protoProp].indexOf ||
        (item => {
          for (let i = 0; i < this.length; i += 1) {
            if (i in this && this[i] === item) {
              return i;
            }
          }
          return -1;
        });

      // Vendors: please allow content code to instantiate DOMExceptions
      // TODO: Use arrow function and bind the this correctly to DOMEx
      const DOMEx = function(type, message) {
        this.name = type;
        this.code = DOMException[type];
        this.message = message;
      };

      const checkTokenAndGetIndex = (classList, token) => {
        if (token === '') {
          throw new DOMEx('SYNTAX_ERR', 'An invalid or illegal string was specified');
        }
        if (/\s/.test(token)) {
          throw new DOMEx('INVALID_CHARACTER_ERR', 'String contains an invalid character');
        }
        return arrIndexOf.call(classList, token);
      };

      const ClassList = elem => {
        const trimmedClasses = strTrim.call(elem.getAttribute('class') || '');
        const classes = trimmedClasses ? trimmedClasses.split(/\s+/) : [];

        for (let i = 0; i < classes.length; i += 1) {
          this.push(classes[i]);
        }

        this.updateClassName = () => {
          elem.setAttribute('class', this.toString());
        };
      };

      const classListProto = [];
      ClassList[protoProp] = [];

      const classListGetter = () => new ClassList(this);

      // Most DOMException implementations don't allow calling DOMException's toString()
      // on non-DOMExceptions. Error's toString() is sufficient here.
      DOMEx[protoProp] = Error[protoProp];
      classListProto.item = i => this[i] || null;
      classListProto.contains = token => checkTokenAndGetIndex(this, String(token)) !== -1;

      classListProto.add = ([...args]) => {
        let token = '';
        let updated = false;

        for (let i = 0; i < args.length; i += 1) {
          token = String(args[i]);
          if (checkTokenAndGetIndex(this, token) === -1) {
            this.push(token);
            updated = true;
          }
        }

        if (updated) {
          this.updateClassName();
        }
      };

      classListProto.remove = (...args) => {
        let token = '';
        let updated = false;
        let index = null;

        for (let i = 0; i < args.length; i += 1) {
          token = String(args[i]);
          index = checkTokenAndGetIndex(this, token);

          while (index !== -1) {
            this.splice(index, 1);
            updated = true;
            index = checkTokenAndGetIndex(this, token);
          }
        }

        if (updated) {
          this.updateClassName();
        }
      };

      classListProto.toggle = (token, force) => {
        const stringToken = String(token);

        const result = this.contains(stringToken);
        const method = result ? force !== true && 'remove' : force !== false && 'add';

        if (method) {
          this[method](stringToken);
        }

        if (force === true || force === false) {
          return force;
        }

        return !result;
      };

      classListProto.toString = () => this.join(' ');

      if (objCtr.defineProperty) {
        const classListPropDesc = {
          get: classListGetter,
          enumerable: true,
          configurable: true,
        };
        try {
          objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
        } catch (ex) {
          // IE 8 doesn't support enumerable:true
          // adding undefined to fight this issue https://github.com/eligrey/classList.js/issues/36
          // modernie IE8-MSW7 machine has IE8 8.0.6001.18702 and is affected
          if (ex.number === undefined || ex.number === -0x7ff5ec54) {
            classListPropDesc.enumerable = false;
            objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
          }
        }
      } else if (objCtr[protoProp].defineProperty) {
        Object.defineProperty(elemCtrProto, classListProp, classListGetter);
      }
    })(window.self);
  }

  // There is full or partial native classList support, so just check if we need
  // to normalize the add/remove and toggle APIs.

  (() => {
    let testElement = document.createElement('_');

    testElement.classList.add('c1', 'c2');

    // Polyfill for IE 10/11 and Firefox <26, where classList.add and
    // classList.remove exist but support only one argument at a time.
    if (!testElement.classList.contains('c2')) {
      const createMethod = method => {
        const original = DOMTokenList.prototype[method];

        DOMTokenList.prototype[method] = (...args) => {
          for (let i = 0; i < args.length; i += 1) {
            const token = args[i];
            original.call(this, token);
          }
        };
      };
      createMethod('add');
      createMethod('remove');
    }

    testElement.classList.toggle('c3', false);

    // Polyfill for IE 10 and Firefox <24, where classList.toggle does not
    // support the second argument.
    if (testElement.classList.contains('c3')) {
      const { toggle } = DOMTokenList.prototype;

      DOMTokenList.prototype.toggle = (...args) => {
        const [token, force] = args;

        if (1 in args && !this.contains(token) === !force) {
          return force;
        }

        return toggle.call(this, token);
      };
    }

    testElement = null;
  })();
}
