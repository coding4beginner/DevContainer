# CSS Exercises with Solutions

## Basic Text Styling

Change the color and size of paragraph text.

```html
<p>This is a sample text.</p>
```

Solution:

```css
p {
  color: red;
  font-size: 20px;
}
```

## Centering Elements

Center a div horizontally and vertically.

```html
<div class="centered">Center me!</div>
```

Solution:

```css
.centered {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}
```

## Styling Links

Change the color of links on hover.

```html
<a href="#">Hover over me!</a>
```

Solution:

```css
a:hover {
  color: green;
}
```

## Creating a Sticky Footer

Create a footer that sticks to the bottom of the viewport.

```html
<footer class="sticky-footer">I'm a sticky footer!</footer>
```

Solution:

```css
.sticky-footer {
  position: fixed;
  bottom: 0;
  width: 100%;
  background-color: #ccc;
}
```

## Using Flexbox for Navigation Bar

Create a horizontal navigation bar using Flexbox.

```html
<nav>
  <a href="#">Home</a>
  <a href="#">About</a>
  <a href="#">Services</a>
  <a href="#">Contact</a>
</nav>
```

Solution:

```css
nav {
  display: flex;
  justify-content: space-around;
  background-color: #333;
  padding: 10px 0;
}

nav a {
color: white;
text-decoration: none;
}
```

## Styling Forms

Style a simple login form.

```html
<form>
    <label for="username">Username:</label>
    <input type="text" id="username" name="username">
    <label for="password">Password:</label>
    <input type="password" id="password" name="password">
    <button type="submit">Login</button>
</form>
```

Solution:

```css
form {
  display: grid;
  gap: 10px;
  width: 200px;
  margin: auto;
}

input, button {
width: 100%;
}
```

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

## Simple Dropdown Menu

Create a simple CSS-only dropdown menu.

```html
<div class="dropdown">
  <button>Menu</button>
  <div class="dropdown-content">
    <a href="#">Link 1</a>
    <a href="#">Link 2</a>
    <a href="#">Link 3</a>
  </div>
</div>
```

Solution:

```css
.dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-content {
    display: none;
    position: absolute;
    background-color: #f9f9f9;
    min-width: 160px;
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
    z-index: 1;
}

.dropdown:hover .dropdown-content {
    display: block;
}
```

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

## Fullscreen Background Image

Set a fullscreen background image that covers the entire viewport.

```html
<div class="fullscreen-background"></div>
```

Solution:

```css
.fullscreen-background {
  background-image: url("your-image.jpg");
  height: 100vh;
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
}
```
