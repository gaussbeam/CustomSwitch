#  CustomSwitch

## Basic Usage
1. Add `CustomSwitch`, or its subclass, to view.
2. (Optional) Configure properties.
  - Color, duration, padding, etc.
3. Execute `configure()`

### Handle value change event
By using `@IBAction` or `addTarget(_: action: for:)`. Example of using `addTarget(_: action: for:)` is below.

```
override func viewDidLoad() {

    self.customSwitch.addTarget(self, action: #selector(self.valueDidChange(_:)), for: .valueChanged)
}

@objc func valueDidChange(_ sender: CustomSwitch) {
    print(sender.inOn)
}
```
