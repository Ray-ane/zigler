{
  "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
  "description": "Line chart of value over time, filtered dynamically by id (auto-populated)",
  "data": {
    "name": "table",                  // give your main dataset a name
    "values": [
      {"id": "A", "date": "2025-01-01", "value": 10},
      {"id": "A", "date": "2025-01-02", "value": 15},
      {"id": "A", "date": "2025-01-03", "value": 12},
      {"id": "B", "date": "2025-01-01", "value": 20},
      {"id": "B", "date": "2025-01-02", "value": 25},
      {"id": "B", "date": "2025-01-03", "value": 22}
    ]
  },

  "params": [
    {
      "name": "selectedId",
      "value": null,                  // start with “All” (no filter)
      "bind": {
        "input": "select",
        // dynamically build an array of unique id’s from your data
        "options": {
          "signal": "Array.from(new Set(data('table').map(function(d){ return d.id; })))"
        },
        // you could also build labels via a signal, e.g. prepend "All"
        // "labels": {"signal": "['All'].concat(Array.from(new Set(data('table').map(d => d.id))) )"}
      }
    }
  ],

  "transform": [
    {
      // if nothing is selected, keep all rows; otherwise filter by id
      "filter": "selectedId == null || datum.id === selectedId"
    }
  ],

  "mark": {
    "type": "line",
    "point": true
  },

  "encoding": {
    "x": {
      "field": "date",
      "type": "temporal",
      "title": "Date"
    },
    "y": {
      "field": "value",
      "type": "quantitative",
      "title": "Value"
    },
    "color": {
      "field": "id",
      "type": "nominal",
      "title": "Series"
    }
  }
}