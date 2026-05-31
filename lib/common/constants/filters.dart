const String vscoPreset = """
[
  {
    "categoryName": "Cool & Refreshing",
    "filters": [
      {
        "filterName": "Cool Breeze",
        "value": {
          "brightness": 0.1,
          "contrast": 1.0,
          "saturation": 1.0,
          "vibrance": 0.0,
          "temperature": -0.8,
          "sepia": 0.0,
          "grain": 0.01
        }
      },
      {
        "filterName": "Icy Blue",
        "value": {
          "brightness": 0.0,
          "contrast": 1.2,
          "saturation": 1.1,
          "vibrance": 0.0,
          "temperature": -1.0,
          "sepia": 0.0,
          "grain": 0.02
        }
      },
      {
        "filterName": "Frozen Tones",
        "value": {
          "brightness": 0.0,
          "contrast": 1.1,
          "saturation": 0.8,
          "vibrance": 0.1,
          "temperature": -0.6,
          "sepia": 0.2,
          "grain": 0.0
        }
      },
      {
        "filterName": "Arctic Chill",
        "value": {
          "brightness": 0.1,
          "contrast": 1.0,
          "saturation": 1.0,
          "vibrance": 0.1,
          "temperature": -0.9,
          "sepia": 0.1,
          "grain": 0.01
        }
      }
    ]
  },
  {
    "categoryName": "Natural & Fresh",
    "filters": [
      {
        "filterName": "Natural",
        "value": {
          "brightness": 0.1,
          "contrast": 1.1,
          "saturation": 1.0,
          "vibrance": 0.1,
          "temperature": 0.0,
          "sepia": 0.0,
          "grain": 0.01
        }
      },
      {
        "filterName": "Bright",
        "value": {
          "brightness": 0.3,
          "contrast": 1.0,
          "saturation": 1.2,
          "vibrance": 0.1,
          "temperature": -0.3,
          "sepia": 0.0,
          "grain": 0.0
        }
      },
      {
        "filterName": "Sunset Glow",
        "value": {
          "brightness": 0.2,
          "contrast": 1.4,
          "saturation": 1.3,
          "vibrance": 0.1,
          "temperature": 0.8,
          "sepia": 0.3,
          "grain": 0.04
        }
      },
      {
        "filterName": "Soft",
        "value": {
          "brightness": 0.05,
          "contrast": 1.0,
          "saturation": 0.8,
          "vibrance": 0.05,
          "temperature": 0.2,
          "sepia": 0.3,
          "grain": 0.02
        }
      }
    ]
  },
  {
    "categoryName": "Moody & Dramatic",
    "filters": [
      {
        "filterName": "Moody",
        "value": {
          "brightness": -0.1,
          "contrast": 1.3,
          "saturation": 0.6,
          "vibrance": -0.1,
          "temperature": 0.7,
          "sepia": 0.4,
          "grain": 0.06
        }
      },
      {
        "filterName": "Vintage",
        "value": {
          "brightness": -0.2,
          "contrast": 1.4,
          "saturation": 0.6,
          "vibrance": -0.2,
          "temperature": 0.9,
          "sepia": 0.7,
          "grain": 0.08
        }
      },
      {
        "filterName": "Vibrant",
        "value": {
          "brightness": 0.2,
          "contrast": 1.2,
          "saturation": 1.4,
          "vibrance": 0.2,
          "temperature": -0.5,
          "sepia": 0.2,
          "grain": 0.03
        }
      }
    ]
  },
  {
    "categoryName": "Vintage & Retro",
    "filters": [
      {
        "filterName": "Vintage",
        "value": {
          "brightness": -0.2,
          "contrast": 1.4,
          "saturation": 0.6,
          "vibrance": -0.2,
          "temperature": 0.9,
          "sepia": 0.7,
          "grain": 0.08
        }
      },
      {
        "filterName": "Sunset Glow",
        "value": {
          "brightness": 0.2,
          "contrast": 1.4,
          "saturation": 1.3,
          "vibrance": 0.1,
          "temperature": 0.8,
          "sepia": 0.3,
          "grain": 0.04
        }
      },
      {
        "filterName": "Soft",
        "value": {
          "brightness": 0.05,
          "contrast": 1.0,
          "saturation": 0.8,
          "vibrance": 0.05,
          "temperature": 0.2,
          "sepia": 0.3,
          "grain": 0.02
        }
      }
    ]
  },
  {
    "categoryName": "Warm & Rich",
    "filters": [
      {
        "filterName": "Red Velvet",
        "value": {
          "brightness": 0.1,
          "contrast": 1.4,
          "saturation": 1.5,
          "vibrance": 0.1,
          "temperature": 0.8,
          "sepia": 0.2,
          "grain": 0.02
        }
      },
      {
        "filterName": "Son Glow",
        "value": {
          "brightness": 0.05,
          "contrast": 1.3,
          "saturation": 1.4,
          "vibrance": 0.2,
          "temperature": 0.9,
          "sepia": 0.3,
          "grain": 0.03
        }
      },
      {
        "filterName": "Golden Hour",
        "value": {
          "brightness": 0.1,
          "contrast": 1.5,
          "saturation": 1.3,
          "vibrance": 0.3,
          "temperature": 1.0,
          "sepia": 0.2,
          "grain": 0.02
        }
      },
      {
        "filterName": "Wine Red",
        "value": {
          "brightness": -0.05,
          "contrast": 1.4,
          "saturation": 1.2,
          "vibrance": 0.1,
          "temperature": 0.7,
          "sepia": 0.3,
          "grain": 0.04
        }
      }
    ]
  },
  {
    "categoryName": "Soft & Elegant",
    "filters": [
      {
        "filterName": "Soft Rose",
        "value": {
          "brightness": 0.0,
          "contrast": 1.2,
          "saturation": 1.2,
          "vibrance": 0.1,
          "temperature": 0.5,
          "sepia": 0.1,
          "grain": 0.01
        }
      },
      {
        "filterName": "Peach Glow",
        "value": {
          "brightness": 0.1,
          "contrast": 1.3,
          "saturation": 1.3,
          "vibrance": 0.2,
          "temperature": 0.6,
          "sepia": 0.2,
          "grain": 0.01
        }
      },
      {
        "filterName": "Elegant Warmth",
        "value": {
          "brightness": 0.1,
          "contrast": 1.2,
          "saturation": 1.1,
          "vibrance": 0.1,
          "temperature": 0.7,
          "sepia": 0.3,
          "grain": 0.02
        }
      }
    ]
  },
  {
    "categoryName": "White & Pink",
    "filters": [
      {
        "filterName": "Pink Glow",
        "value": {
          "brightness": 0.2,
          "contrast": 1.1,
          "saturation": 1.1,
          "vibrance": 0.2,
          "temperature": 0.3,
          "sepia": 0.1,
          "grain": 0.01
        }
      },
      {
        "filterName": "Blush White",
        "value": {
          "brightness": 0.3,
          "contrast": 1.0,
          "saturation": 1.2,
          "vibrance": 0.1,
          "temperature": 0.2,
          "sepia": 0.0,
          "grain": 0.0
        }
      },
      {
        "filterName": "Baby Pink",
        "value": {
          "brightness": 0.1,
          "contrast": 1.1,
          "saturation": 1.3,
          "vibrance": 0.2,
          "temperature": 0.4,
          "sepia": 0.0,
          "grain": 0.01
        }
      },
      {
        "filterName": "Soft Blush",
        "value": {
          "brightness": 0.2,
          "contrast": 1.2,
          "saturation": 1.1,
          "vibrance": 0.1,
          "temperature": 0.3,
          "sepia": 0.0,
          "grain": 0.0
        }
      }
    ]
  }
]
""";