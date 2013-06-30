(function() {
  var Size, types;

  types = {};

  Size = types.size = function(string) {
    var prefix, size, sizeParts;
    size = String(string);
    sizeParts = string.exec(/^(LT)(\d)\/(\d)R(\d)/);
    if (/\D/.test(size[0])) {
      prefix = size.shift();
    }
    size.width = size.shift();
    size.diameter = size.shift();
    size.weightLimit = size.shift();
    if (prefix) {
      size.prefix = prefix;
    }
    size.isP = this.isP.bind(this);
    size.isLT = this.isLT.bind(this);
    return size;
  };

  Size.prototype.isP = function() {
    return this.prefix === 'P';
  };

  Size.prototype.isLT = function() {
    return this.prefix === 'LT';
  };

  type.promotion = function(obj) {
    if (obj == null) {
      obj = {};
    }
    if (obj.when) {
      this.when = obj.when;
    }
    if (obj["do"]) {
      return this["do"] = obj["do"];
    }
  };

  types.Tire = function(obj) {
    var promo, _i, _len, _ref;
    if (obj == null) {
      obj = {};
    }
    this.size = types.size(obj.size);
    this.promotions = [];
    _ref = obj.promotions;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      promo = _ref[_i];
      this.promotions.push(new type.promotion(promo));
    }
    this.bwStaggered;
    this.setFlags();
    this.attributes = obj;
    return this;
  };

  types.Tire.prototype.setFlags = function() {
    var allSeasonFlag, ltFlag, oeaFlag, oemFlag, pFlag, promotionsFlag, staggeredFlag, threeSeasonFlag, winterFlag;
    if (this.attributes.isWinter) {
      winterFlag = 0x1;
    }
    if (this.attributes.season === '3 season') {
      threeSeasonFlag = 0x2;
    }
    if (this.attributes.season === 'all season') {
      allSeasonFlag = 0x4;
    }
    if (this.attributes.staggered) {
      staggeredFlag = 0x8;
    }
    if (this.promotions.length > 0) {
      promotionsFlag = 0x16;
    }
    if (this.attributes.program === 'OEM') {
      oemFlag = 0x32;
    }
    if (this.attributes.program === 'OEA') {
      oeaFlag = 0x64;
    }
    if (this.size.isP()) {
      pFlag = 0x128;
    }
    if (this.size.isLT()) {
      ltFlag = 0x256;
    }
    this.bwFlags = winterFlag | threeSeasonFlag | allSeasonFlag | staggeredFlag | promotionsFlag | oemFlag | oeaFlag;
    return this;
  };

}).call(this);

/*
//@ sourceMappingURL=plugin.js.map
*/