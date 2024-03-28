// Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the ones in pr_test.go
package test

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

const basicExampleDir = "examples/basic"

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	t.Skip("Skipping upgrade test until initial code is in master branch")

	options := setupOptions(t, "event-notification-basic", basicExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
