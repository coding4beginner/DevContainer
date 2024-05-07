## Zebra Striped Table

Create a table with zebra-striped rows.

```html
<table>
  <tr>
    <td>Row 1, Cell 1</td>
    <td>Row 1, Cell 2</td>
  </tr>
  <tr>
    <td>Row 2, Cell 1</td>
    <td>Row 2, Cell 2</td>
  </tr>
  <tr>
    <td>Row 3, Cell 1</td>
    <td>Row 3, Cell 2</td>
  </tr>
</table>
```

Solution:

```css
tr:nth-child(odd) {
  background-color: #f2f2f2;
}
```
