"""Test custom Django management commands"""

# Mock db
from unittest.mock import patch
# Possible error
from psycopg2 import OperationalError as Psycopg2Error
# Built in django funcion to call a command
from django.core.management import call_command
# Possible error
from django.db.utils import OperationalError
# Base test class
from django.test import SimpleTestCase


@patch('core.management.commands.wait_for_db.Command.check')
class CommandTests(SimpleTestCase):

    def test_wait_for_db_ready(self, patched_check):
        """Test waiting for database if database ready"""
        patched_check.return_value = True
        call_command('wait_for_db')
        patched_check.assert_called_once_with(databases=['default'])

    @patch('time.sleep')
    def test_wait_for_db_delay(self, patched_sleep, patched_check):
        """Test waiting for database when getting OperationalError"""
        patched_check.side_effect = [Psycopg2Error] * \
            2 + [OperationalError] * 3 + [True]
        call_command('wait_for_db')
        self.assertEqual(patched_check.call_count, 6)
        patched_check.assert_called_with(databases=['default'])
