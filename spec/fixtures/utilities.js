Array.prototype.is_empty = function() {
	return is_empty(this);
};

Array.prototype.not_empty = function() {
	return is_not_empty(this);
};

Array.prototype.each = function(callback) {
	if(is_undefined(callback)) {
		throw new SyntaxError("Array.each(callback): callback is undefined");
	}

	for (var i = 0; i < this.length; i++) {
		var args = [this[i], i];
		callback.apply(this, args);
	}
};

Array.prototype.contains = function(suspect) {
	var matches = [];
	this.each(function(value, index) {
		if(value === suspect) {
			matches.push(index);
		}
	});

	return matches.not_empty() ? matches : false;
};
String.prototype.is_empty = function() {
	return (this.length < 1) ? true : false;
};

String.prototype.not_empty = function() {
	return (this.length < 1) ? false : true;
};

String.prototype.is_numeric = function() {
	var pattern = /^(\.|-)?\d+(?:\.\d*)?(?:e[+\-]?\d+)?$/i;
	return pattern.test(this);
};

String.prototype.trim = function() {
	return this.replace(/^\s+|\s+$/g, "");
};

String.prototype.ltrim = function() {
	return this.replace(/^\s+/,"");
};

String.prototype.rtrim = function() {
	return this.replace(/\s+$/,"");
};

String.prototype.each = function(callback) {
	if(is_undefined(callback)) {
		throw new SyntaxError("String.each(callback): callback is undefined");
	}

	for (var i = 0; i < this.length; i++) {
		var args = [this.charAt(i), i];
		callback.apply(this, args);
	}
};

String.prototype.capitalize = function() {
	return this.substr(0, 1).toUpperCase() + this.substr(1);
};

String.prototype.reverse = function() {
	return this.split('').reverse().join('');
};

String.prototype.to_n = function() {
	return parseFloat(this);
};

String.prototype.pluck = function(needle) {
	var pattern = new RegExp(needle, 'g');
	return this.replace(pattern, '');
};

String.prototype.single_space = function() {
	var no_hard_spaces = this.replace(/\&nbsp\;/g, ' ');
	return no_hard_spaces.replace(/\s+/g, ' ');
};

String.prototype.compress = function() {
	return this.replace(/\s+/g, '');
};
Number.prototype.to_hex = function() {
	if (this === 0) {
		return "00";
	}

	var chars = "0123456789ABCDEF";
	var n = Math.max(0, this);
	n = Math.min(n, 255);
	n = Math.round(n);
	return chars.charAt((n - n % 16)/16) + chars.charAt(n % 16);
};
var CSS = function() {};

CSS.rgb2hex = function(r,g,b) {
	pattern = /(\d{1,3})\,\s?(\d{1,3})\,\s?(\d{1,3})/gi;
	var rgb;
	if (is_typeof(String, r)) {
		rgb = r.match(pattern);
		rgb = rgb[0].split(',');
	}
	else {
		rgb = false;
	}

	if (rgb) {
		r = parseInt(rgb[0], 10);
		g = parseInt(rgb[1], 10);
		b = parseInt(rgb[2], 10);
	}
	else {
		r = parseInt(r, 10);
		g = parseInt(g, 10);
		b = parseInt(b, 10);
	}
	return '#' + r.to_hex() + g.to_hex() + b.to_hex();
};

CSS.hex2rgb = function(hex) {
	hex = hex.replace('#', '');

	var rgb = [];

	rgb[0] = parseInt(hex.substring(0,2), 16);
	rgb[1] = parseInt(hex.substring(2,4), 16);
	rgb[2] = parseInt(hex.substring(4,6), 16);

	rgb.red = rgb[0];
	rgb.green = rgb[1];
	rgb.blue = rgb[2];

	rgb.to_s = function() {
		return 'rgb(' + rgb.red +', ' + rgb.green + ', ' + rgb.blue + ')';
	};

	rgb.each = function(callback) {
		for (var i = 0; i < 3; i++) {
			callback.call(this, rgb[i]);
		}
	};

	return rgb;
};
var Cookie = function(name, data, exp) {
	if (is_undefined(name)) {
		throw new SyntaxError('new Cookie(name, data[, exp]): name is undefined');
	}

	function set_exp(days) {
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		var expires = "; expires=" + date.toGMTString();
	}

	this.name = name;

	unless(this.read(), function() {
		if (is_undefined(data)) {
			this.data = '';
		}
		else {
			this.data = data;
		}

		if (is_defined(days)) {
			this.exp = set_exp(days);
		}
		else {
			this.exp = '';
		}
	});

	this.save();
};

Cookie.prototype.save = function() {
	document.cookie = this.name + "=" + this.data + this.exp + "; path=/";
};

Cookie.prototype.read = function() {
	var nameEQ = this.name + "=";
	var ca = document.cookie.split(';');
	var length = ca.length;

	for (var i = 0; i < length; i++) {
		var c = ca[i];
		while (c.charAt(0) == ' ') {
			c = c.substring(1, c.length);
		}
		if (c.indexOf(nameEQ) === 0) {
			return c.substring(nameEQ.length,c.length);
		}
	}

	return null;
};

Cookie.prototype.remove = function() {
	this.data = '';
	this.exp = -1;
	this.save();
};
