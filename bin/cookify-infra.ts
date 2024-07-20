#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { CookifyInfraStack } from '../lib/cookify-infra-stack';

const app = new cdk.App();
new CookifyInfraStack(app, 'CookifyInfraStack', {
});