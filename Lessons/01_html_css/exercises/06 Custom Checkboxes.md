## Custom Checkboxes

Style custom checkboxes.

```html
<label class="custom-checkbox">
    <input type="checkbox">
    <span>Check me</span>
</label>
```

Solution:

```css
.custom-checkbox input {
    display: none;
}

.custom-checkbox span {
    padding: 5px;
    border: 1px solid #ddd;
    display: inline-block;
}

.custom-checkbox input:checked + span {
    background-color: #f00;
    color: #fff;
}
```