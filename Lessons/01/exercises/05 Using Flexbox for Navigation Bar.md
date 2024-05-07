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
