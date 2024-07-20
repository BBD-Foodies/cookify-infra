#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { CookifyInfraStack } from '../lib/cookify-infra-stack';

const app = new cdk.App();
new CookifyInfraStack(app, 'CookifyInfraStack', {
  apiCertArn: 'arn:aws:acm:eu-west-1:535492056399:certificate/b7059636-1708-41ac-8481-b0037fc49c7f',
  apiDomain: 'api.cookify.phipson.co.za',
  ec2KeyPairName: 'cookify-ec2-key',
  ghOrgName: 'BBD-Foodies',
  namingPrefix: 'cookify',
});