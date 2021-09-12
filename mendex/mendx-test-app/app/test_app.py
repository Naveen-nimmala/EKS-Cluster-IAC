import unittest
import hug
import app


class TestApp(unittest.TestCase):
    def test_hello_world(self):
        response = hug.test.get(app, '/', {})
        self.assertEqual(response.status, '200 OK')
        self.assertEqual(response.data, "Hello World!")

