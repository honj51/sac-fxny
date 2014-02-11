/*
Data plugin for Highcharts

(c) 2012-2013 Torstein Hønsi
Last revision 2012-11-27

License: www.highcharts.com/license
*/
(function (f) {
    var k = f.each, n = function (a) { this.init(a) }; f.extend(n.prototype, { init: function (a) { this.options = a; this.columns = a.columns || this.rowsToColumns(a.rows) || []; this.columns.length ? this.dataFound() : (this.parseCSV(), this.parseTable(), this.parseGoogleSpreadsheet()) }, dataFound: function () { this.parseTypes(); this.findHeaderRow(); this.parsed(); this.complete() }, parseCSV: function () {
        var a = this, b = this.options, c = b.csv, d = this.columns, e = b.startRow || 0, g = b.endRow || Number.MAX_VALUE, h = b.startColumn || 0, l = b.endColumn ||
Number.MAX_VALUE, q = 0; c && (c = c.replace(/\r\n/g, "\n").replace(/\r/g, "\n").split(b.lineDelimiter || "\n"), k(c, function (c, m) { var o = a.trim(c), f = o.indexOf("#") === 0; m >= e && m <= g && !f && o !== "" && (o = c.split(b.itemDelimiter || ","), k(o, function (b, a) { a >= h && a <= l && (d[a - h] || (d[a - h] = []), d[a - h][q] = b) }), q += 1) }), this.dataFound())
    }, parseTable: function () {
        var a = this.options, b = a.table, c = this.columns, d = a.startRow || 0, e = a.endRow || Number.MAX_VALUE, g = a.startColumn || 0, h = a.endColumn || Number.MAX_VALUE, l; b && (typeof b === "string" && (b = document.getElementById(b)),
k(b.getElementsByTagName("tr"), function (a, b) { l = 0; b >= d && b <= e && k(a.childNodes, function (a) { if ((a.tagName === "TD" || a.tagName === "TH") && l >= g && l <= h) c[l] || (c[l] = []), c[l][b - d] = a.innerHTML, l += 1 }) }), this.dataFound())
    }, parseGoogleSpreadsheet: function () {
        var a = this, b = this.options, c = b.googleSpreadsheetKey, d = this.columns, e = b.startRow || 0, g = b.endRow || Number.MAX_VALUE, h = b.startColumn || 0, l = b.endColumn || Number.MAX_VALUE, f, j; c && jQuery.getJSON("https://spreadsheets.google.com/feeds/cells/" + c + "/" + (b.googleSpreadsheetWorksheet ||
"od6") + "/public/values?alt=json-in-script&callback=?", function (b) { var b = b.feed.entry, c, k = b.length, n = 0, p = 0, i; for (i = 0; i < k; i++) c = b[i], n = Math.max(n, c.gs$cell.col), p = Math.max(p, c.gs$cell.row); for (i = 0; i < n; i++) if (i >= h && i <= l) d[i - h] = [], d[i - h].length = Math.min(p, g - e); for (i = 0; i < k; i++) if (c = b[i], f = c.gs$cell.row - 1, j = c.gs$cell.col - 1, j >= h && j <= l && f >= e && f <= g) d[j - h][f - e] = c.content.$t; a.dataFound() })
    }, findHeaderRow: function () { k(this.columns, function () { }); this.headerRow = 0 }, trim: function (a) {
        return typeof a === "string" ? a.replace(/^\s+|\s+$/g,
"") : a
    }, parseTypes: function () { for (var a = this.columns, b = a.length, c, d, e, g; b--; ) for (c = a[b].length; c--; ) d = a[b][c], e = parseFloat(d), g = this.trim(d), g == e ? (a[b][c] = e, e > 31536E6 ? a[b].isDatetime = !0 : a[b].isNumeric = !0) : (d = this.parseDate(d), b === 0 && typeof d === "number" && !isNaN(d) ? (a[b][c] = d, a[b].isDatetime = !0) : a[b][c] = g === "" ? null : g) }, dateFormats: { "YYYY-mm-dd": { regex: "^([0-9]{4})-([0-9]{2})-([0-9]{2})$", parser: function (a) { return Date.UTC(+a[1], a[2] - 1, +a[3]) } } }, parseDate: function (a) {
        var b = this.options.parseDate, c, d,
e; b && (c = b(a)); if (typeof a === "string") for (d in this.dateFormats) b = this.dateFormats[d], (e = a.match(b.regex)) && (c = b.parser(e)); return c
    }, rowsToColumns: function (a) { var b, c, d, e, g; if (a) { g = []; c = a.length; for (b = 0; b < c; b++) { e = a[b].length; for (d = 0; d < e; d++) g[d] || (g[d] = []), g[d][b] = a[b][d] } } return g }, parsed: function () { this.options.parsed && this.options.parsed.call(this, this.columns) }, complete: function () {
        var a = this.columns, b, c, d, e, g = this.options, h, f, k, j, m; if (g.complete) {
            a.length > 1 && (d = a.shift(), this.headerRow === 0 &&
d.shift(), (b = d.isNumeric || d.isDatetime) || (c = d), d.isDatetime && (e = "datetime")); h = []; for (j = 0; j < a.length; j++) { this.headerRow === 0 && (k = a[j].shift()); f = []; for (m = 0; m < a[j].length; m++) f[m] = a[j][m] !== void 0 ? b ? [d[m], a[j][m]] : a[j][m] : null; h[j] = { name: k, data: f} } g.complete({ xAxis: { categories: c, type: e }, series: h })
        } 
    } 
    }); f.Data = n; f.data = function (a) { return new n(a) }; f.wrap(f.Chart.prototype, "init", function (a, b, c) {
        var d = this; b && b.data ? f.data(f.extend(b.data, { complete: function (e) {
            b.series && k(b.series, function (a, c) {
                b.series[c] =
f.merge(a, e.series[c])
            }); b = f.merge(e, b); a.call(d, b, c)
        } 
        })) : a.call(d, b, c)
    })
})(Highcharts);
